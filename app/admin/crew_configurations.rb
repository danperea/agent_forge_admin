ActiveAdmin.register CrewConfiguration do
  menu priority: 4

  permit_params :crew_type, :name, :description, :is_active, :configuration

  index do
    selectable_column
    id_column
    column :name
    column :crew_type
    column :description do |crew|
      truncate(crew.description, length: 80)
    end
    column :status_badge, sortable: :is_active
    column :agents_summary
    column :executions_count
    column :created_at
    actions
  end

  filter :name
  filter :crew_type, as: :select, collection: [
    'requirements', 'architecture', 'design_systems', 'ux_design',
    'project_management', 'implementation', 'qa', 'custom'
  ]
  filter :is_active, as: :select, collection: [['Active', true], ['Inactive', false]]
  filter :created_at

  form do |f|
    f.inputs "Crew Configuration" do
      f.input :name
      f.input :description, as: :text, rows: 4
      f.input :crew_type, as: :select, collection: [
        ['Requirements Analysis', 'requirements'],
        ['System Architecture', 'architecture'],
        ['Design Systems', 'design_systems'],
        ['UX Design', 'ux_design'],
        ['Project Management', 'project_management'],
        ['Implementation', 'implementation'],
        ['Quality Assurance', 'qa'],
        ['Custom', 'custom']
      ]
      f.input :is_active, as: :boolean
    end

    f.inputs "Configuration (JSON)" do
      f.input :configuration, as: :text, rows: 8,
              hint: "Enter JSON configuration for the crew"
    end

    f.actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :description
      row :crew_type
      row :status_badge
      row :agents_count
      row :executions_count
      row :created_at
      row :updated_at
    end

    panel "Agents" do
      if crew_configuration.parsed_agents.any?
        table_for crew_configuration.parsed_agents do
          column "Role" do |agent|
            agent['role'] || agent[:role]
          end
          column "Goal" do |agent|
            agent['goal'] || agent[:goal]
          end
          column "Backstory" do |agent|
            truncate(agent['backstory'] || agent[:backstory] || '', length: 100)
          end
          column "Tools" do |agent|
            tools = agent['tools'] || agent[:tools] || []
            tools.is_a?(Array) ? tools.join(', ') : tools
          end
        end
      else
        div "No agents configured"
      end
    end

    panel "Configuration" do
      if crew_configuration.parsed_configuration.any?
        pre JSON.pretty_generate(crew_configuration.parsed_configuration)
      else
        div "No configuration data"
      end
    end
  end

  # Custom action to toggle active status
  member_action :toggle_status, method: :patch do
    resource.is_active = !resource.is_active
    if resource.save
      redirect_to resource_path, notice: "Crew configuration #{resource.is_active? ? 'activated' : 'deactivated'}"
    else
      redirect_to resource_path, alert: 'Failed to update status'
    end
  end

  action_item :toggle_status, only: :show do
    link_to(
      crew_configuration.is_active? ? 'Deactivate' : 'Activate',
      toggle_status_admin_crew_configuration_path(crew_configuration),
      method: :patch,
      class: 'button'
    )
  end

  # Batch action to activate/deactivate multiple crews
  batch_action :activate do |ids|
    updated_count = 0
    ids.each do |id|
      crew = CrewConfiguration.find(id)
      if crew
        crew.is_active = true
        updated_count += 1 if crew.save
      end
    end
    redirect_to collection_path, notice: "#{updated_count} crew configuration(s) activated"
  end

  batch_action :deactivate do |ids|
    updated_count = 0
    ids.each do |id|
      crew = CrewConfiguration.find(id)
      if crew
        crew.is_active = false
        updated_count += 1 if crew.save
      end
    end
    redirect_to collection_path, notice: "#{updated_count} crew configuration(s) deactivated"
  end
end