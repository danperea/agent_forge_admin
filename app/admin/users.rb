ActiveAdmin.register User do
  menu priority: 1

  permit_params :email, :first_name, :last_name, :openai_api_key,
                :anthropic_api_key, :atlassian_domain, :atlassian_api_token,
                :atlassian_user_email, :atlassian_account_id, :github_token,
                :github_username, :crewai_api_key

  index do
    selectable_column
    id_column
    column :email
    column :full_name
    column :first_name
    column :last_name
    column "API Keys" do |user|
      keys = []
      keys << "OpenAI" if user.openai_api_key.present?
      keys << "Anthropic" if user.anthropic_api_key.present?
      keys << "CrewAI" if user.crewai_api_key.present?
      keys << "GitHub" if user.github_token.present?
      keys << "Atlassian" if user.atlassian_api_token.present?
      keys.any? ? keys.join(", ") : "None"
    end
    column :created_at
    actions
  end

  filter :email
  filter :first_name
  filter :last_name
  filter :created_at

  form do |f|
    f.inputs "User Details" do
      f.input :email
      f.input :first_name
      f.input :last_name
    end

    f.inputs "API Keys", collapsed: true do
      f.input :openai_api_key, label: "OpenAI API Key",
              hint: "API key for OpenAI services"
      f.input :anthropic_api_key, label: "Anthropic API Key",
              hint: "API key for Claude/Anthropic services"
      f.input :crewai_api_key, label: "CrewAI API Key",
              hint: "API key for CrewAI services"
    end

    f.inputs "GitHub Integration", collapsed: true do
      f.input :github_token, label: "GitHub Token",
              hint: "Personal access token for GitHub"
      f.input :github_username, label: "GitHub Username"
    end

    f.inputs "Atlassian Integration", collapsed: true do
      f.input :atlassian_domain, label: "Atlassian Domain",
              hint: "e.g., yourcompany.atlassian.net"
      f.input :atlassian_api_token, label: "Atlassian API Token"
      f.input :atlassian_user_email, label: "Atlassian User Email"
      f.input :atlassian_account_id, label: "Atlassian Account ID"
    end

    f.actions
  end

  show do
    attributes_table do
      row :id
      row :email
      row :first_name
      row :last_name
      row :full_name
      row :created_at
      row :updated_at
    end

    panel "API Keys & Integrations" do
      attributes_table_for user do
        row("OpenAI API Key") { user.openai_api_key.present? ? "Set (#{user.openai_api_key[0..10]}...)" : "Not set" }
        row("Anthropic API Key") { user.anthropic_api_key.present? ? "Set (#{user.anthropic_api_key[0..10]}...)" : "Not set" }
        row("CrewAI API Key") { user.crewai_api_key.present? ? "Set (#{user.crewai_api_key[0..10]}...)" : "Not set" }
        row("GitHub Token") { user.github_token.present? ? "Set (#{user.github_token[0..10]}...)" : "Not set" }
        row("GitHub Username") { user.github_username }
        row("Atlassian Domain") { user.atlassian_domain }
        row("Atlassian API Token") { user.atlassian_api_token.present? ? "Set (#{user.atlassian_api_token[0..10]}...)" : "Not set" }
        row("Atlassian User Email") { user.atlassian_user_email }
        row("Atlassian Account ID") { user.atlassian_account_id }
      end
    end
  end
end