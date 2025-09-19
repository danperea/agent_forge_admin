# frozen_string_literal: true
ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    # Agent Forge Admin Dashboard
    div class: "dashboard_header" do
      h1 "Agent Forge Admin Dashboard", style: "color: #333; margin-bottom: 10px;"
      p "Manage your Agent Forge API data and configurations", style: "color: #666; font-size: 16px;"
    end

    columns do
      column do
        panel "Quick Stats" do
          begin
            users_count = User.all.count
            projects_count = Project.all.count
            crews_count = CrewConfiguration.all.count
            tasks_count = AgentTask.all.count

            table_for [
              { label: "Total Users", count: users_count, link: admin_users_path },
              { label: "Active Projects", count: projects_count, link: admin_projects_path },
              { label: "Crew Configurations", count: crews_count, link: admin_crew_configurations_path },
              { label: "Agent Tasks", count: tasks_count, link: admin_agent_tasks_path }
            ] do
              column("Metric") { |row| row[:label] }
              column("Count") { |row| row[:count] }
              column("") { |row| link_to "View All", row[:link], class: "button small" }
            end
          rescue => e
            div "Unable to load statistics: #{e.message}", class: "error"
          end
        end
      end

      column do
        panel "Recent Activity" do
          begin
            recent_projects = Project.all.sort_by(&:created_at).reverse.first(5)
            if recent_projects.any?
              ul do
                recent_projects.each do |project|
                  li do
                    link_to(project.name, admin_project_path(project)) +
                    " - #{time_ago_in_words(project.created_at)} ago"
                  end
                end
              end
            else
              div "No recent projects"
            end
          rescue => e
            div "Unable to load recent activity: #{e.message}", class: "error"
          end
        end
      end
    end

    columns do
      column do
        panel "System Health" do
          begin
            # Test API connectivity
            api_client = AgentForgeApiClient.new
            response = api_client.get_projects

            if response.success?
              div "✅ Agent Forge API: Connected", class: "status_tag ok"
            else
              div "❌ Agent Forge API: Error (#{response.code})", class: "status_tag error"
            end
          rescue => e
            div "❌ Agent Forge API: Connection Failed", class: "status_tag error"
            div "Error: #{e.message}", style: "font-size: 12px; color: #999; margin-top: 5px;"
          end
        end
      end

      column do
        panel "Quick Actions" do
          div style: "padding: 10px 0;" do
            link_to "Create New Project", new_admin_project_path, class: "button"
          end
          div style: "padding: 10px 0;" do
            link_to "Add User", new_admin_user_path, class: "button"
          end
          div style: "padding: 10px 0;" do
            link_to "Configure Crew", new_admin_crew_configuration_path, class: "button"
          end
          div style: "padding: 10px 0;" do
            link_to "Create Agent Task", new_admin_agent_task_path, class: "button"
          end
        end
      end
    end

    columns do
      column span: 2 do
        panel "API Configuration" do
          div "Agent Forge API URL: #{ENV.fetch('AGENT_FORGE_API_URL', 'http://localhost:3002')}"
          div style: "margin-top: 10px; font-size: 12px; color: #666;" do
            "Configure the AGENT_FORGE_API_URL environment variable to point to your Agent Forge API instance."
          end
        end
      end
    end
  end # content
end
