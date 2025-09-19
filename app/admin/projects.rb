ActiveAdmin.register Project do
  menu priority: 2

  permit_params :name, :description, :status, :repository_url, :github_owner,
                :github_repo, :confluence_space, :jira_project, :progress_percentage,
                tech_stack: []

  index do
    selectable_column
    id_column
    column :name
    column :description do |project|
      truncate(project.description, length: 100)
    end
    column :status do |project|
      status_tag project.status, case project.status
                                  when 'active' then :ok
                                  when 'completed' then :green
                                  when 'on_hold' then :warning
                                  when 'cancelled' then :error
                                  else :default
                                  end
    end
    column :progress_percentage do |project|
      "#{project.progress_percentage}%"
    end
    column :tech_stack_display
    column :created_at
    actions
  end

  filter :name
  filter :status, as: :select, collection: ['planning', 'active', 'on_hold', 'completed', 'cancelled']
  filter :created_at

  form do |f|
    f.inputs "Project Details" do
      f.input :name
      f.input :description, as: :text, rows: 4
      f.input :status, as: :select, collection: [
        ['Planning', 'planning'],
        ['Active', 'active'],
        ['On Hold', 'on_hold'],
        ['Completed', 'completed'],
        ['Cancelled', 'cancelled']
      ]
      f.input :progress_percentage, as: :number, in: 0..100, step: 1
    end

    f.inputs "Technology Stack" do
      f.input :tech_stack, as: :tags, collection: [
        'Ruby', 'Rails', 'JavaScript', 'React', 'Vue.js', 'Angular', 'Node.js',
        'Python', 'Django', 'Flask', 'PHP', 'Laravel', 'Java', 'Spring',
        'C#', '.NET', 'Go', 'Rust', 'Swift', 'Kotlin', 'Scala',
        'PostgreSQL', 'MySQL', 'MongoDB', 'Redis', 'Elasticsearch',
        'AWS', 'Azure', 'GCP', 'Docker', 'Kubernetes', 'Jenkins', 'GitLab CI',
        'TensorFlow', 'PyTorch', 'Scikit-learn', 'OpenAI', 'Anthropic'
      ]
    end

    f.inputs "Repository Integration" do
      f.input :repository_url, label: "Repository URL"
      f.input :github_owner, label: "GitHub Owner"
      f.input :github_repo, label: "GitHub Repository"
    end

    f.inputs "Atlassian Integration" do
      f.input :confluence_space, label: "Confluence Space"
      f.input :jira_project, label: "JIRA Project Key"
    end

    f.actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :description
      row :status do |project|
        status_tag project.status
      end
      row :progress_percentage do |project|
        "#{project.progress_percentage}%"
      end
      row :tech_stack_display
      row :repository_url do |project|
        if project.repository_url.present?
          link_to project.repository_url, project.repository_url, target: '_blank'
        end
      end
      row :github_owner
      row :github_repo
      row :confluence_space
      row :jira_project
      row :created_at
      row :updated_at
    end

    panel "Project Statistics" do
      if project.parsed_stats.any?
        attributes_table_for project do
          row("Total Tasks") { project.parsed_stats['total_tasks'] || 0 }
          row("Completed Tasks") { project.parsed_stats['completed_tasks'] || 0 }
          row("Artifacts Count") { project.parsed_stats['artifacts_count'] || 0 }
          row("Conversations Count") { project.parsed_stats['conversations_count'] || 0 }
        end
      else
        div "No statistics available"
      end
    end

    panel "Related Items" do
      h4 "Quick Links"
      ul do
        li link_to "View Agent Tasks", admin_agent_tasks_path(q: { project_id_eq: project.id })
        li link_to "View Artifacts", "#" # TODO: Add when artifact admin is created
        li link_to "View Crew Executions", "#" # TODO: Add when crew execution admin is created
      end
    end
  end

  # Custom action to view project details
  member_action :execute_workflow, method: :post do
    # TODO: Add workflow execution logic
    redirect_to resource_path, notice: 'Workflow execution initiated'
  end

  action_item :execute_workflow, only: :show do
    link_to 'Execute Workflow', execute_workflow_admin_project_path(project), method: :post,
            data: { confirm: 'Are you sure you want to execute the workflow for this project?' },
            class: 'button'
  end
end