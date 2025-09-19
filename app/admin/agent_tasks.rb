ActiveAdmin.register AgentTask do
  menu priority: 3

  permit_params :project_id, :agent_type, :title, :description, :status, :priority,
                :input_data, :estimated_duration

  index do
    selectable_column
    id_column
    column :project do |task|
      task.project&.name || "Project ##{task.project_id}"
    end
    column :title
    column :agent_type
    column :status_badge, sortable: :status
    column :priority_badge, sortable: :priority
    column :estimated_duration do |task|
      "#{task.estimated_duration} min" if task.estimated_duration.present?
    end
    column :assigned_at
    column :completed_at
    actions do |task|
      if task.status != 'completed' && task.status != 'in_progress'
        item "Execute", execute_admin_agent_task_path(task), method: :post,
             data: { confirm: 'Execute this task?' }, class: 'button'
      end
    end
  end

  filter :agent_type, as: :select, collection: [
    'architect', 'product_manager', 'technical_manager', 'design_systems',
    'ux_design', 'software_engineer', 'qa', 'devops', 'data_scientist'
  ]
  filter :status, as: :select, collection: ['pending', 'in_progress', 'completed', 'failed']
  filter :priority, as: :select, collection: ['low', 'medium', 'high', 'urgent']
  filter :created_at

  form do |f|
    f.inputs "Task Details" do
      f.input :project_id, as: :select, collection: Project.all.map { |p| [p.name, p.id] },
              prompt: "Select a project"
      f.input :title
      f.input :description, as: :text, rows: 4
      f.input :agent_type, as: :select, collection: [
        ['System Architect', 'architect'],
        ['Product Manager', 'product_manager'],
        ['Technical Manager', 'technical_manager'],
        ['Design Systems Engineer', 'design_systems'],
        ['UX Designer', 'ux_design'],
        ['Software Engineer', 'software_engineer'],
        ['QA Engineer', 'qa'],
        ['DevOps Engineer', 'devops'],
        ['Data Scientist', 'data_scientist']
      ]
      f.input :priority, as: :select, collection: [
        ['Low', 'low'],
        ['Medium', 'medium'],
        ['High', 'high'],
        ['Urgent', 'urgent']
      ]
      f.input :estimated_duration, label: "Estimated Duration (minutes)"
    end

    f.inputs "Input Data (JSON)" do
      f.input :input_data, as: :text, rows: 6,
              hint: "Enter JSON data for the task input"
    end

    f.actions
  end

  show do
    attributes_table do
      row :id
      row :project do |task|
        if task.project
          link_to task.project.name, admin_project_path(task.project)
        else
          "Project ##{task.project_id}"
        end
      end
      row :title
      row :description
      row :agent_type
      row :status_badge
      row :priority_badge
      row :estimated_duration do |task|
        "#{task.estimated_duration} minutes" if task.estimated_duration.present?
      end
      row :interactions_count
      row :assigned_at
      row :completed_at
      row :created_at
      row :updated_at
    end

    panel "Input Data" do
      if agent_task.input_data.present?
        pre JSON.pretty_generate(agent_task.input_data)
      else
        div "No input data provided"
      end
    end

    panel "Output Data" do
      if agent_task.output_data.present?
        pre agent_task.output_data
      else
        div "No output data available"
      end
    end

    if agent_task.error_message.present?
      panel "Error Information", class: 'error' do
        div agent_task.error_message
      end
    end
  end

  # Custom action to execute a task
  member_action :execute, method: :post do
    if resource.execute!
      redirect_to resource_path, notice: 'Task execution initiated successfully'
    else
      redirect_to resource_path, alert: 'Failed to execute task'
    end
  end

  action_item :execute, only: :show do
    if agent_task.status != 'completed' && agent_task.status != 'in_progress'
      link_to 'Execute Task', execute_admin_agent_task_path(agent_task), method: :post,
              data: { confirm: 'Are you sure you want to execute this task?' },
              class: 'button'
    end
  end

  # Batch action to execute multiple tasks
  batch_action :execute_tasks do |ids|
    executed_count = 0
    ids.each do |id|
      task = AgentTask.find(id)
      executed_count += 1 if task&.execute!
    end
    redirect_to collection_path, notice: "#{executed_count} task(s) executed successfully"
  end
end