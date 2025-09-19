class AgentForgeApiClient
  include HTTParty

  base_uri ENV.fetch('AGENT_FORGE_API_URL', 'http://localhost:3002')

  def initialize(token = nil)
    @token = token
    @headers = {
      'Content-Type' => 'application/json',
      'Accept' => 'application/json'
    }
    @headers['Authorization'] = "Bearer #{@token}" if @token
  end

  # Users
  def get_users
    self.class.get('/api/v1/users', headers: @headers)
  end

  def get_user(id)
    self.class.get("/api/v1/users/#{id}", headers: @headers)
  end

  def create_user(user_data)
    self.class.post('/api/v1/users',
      body: { user: user_data }.to_json,
      headers: @headers
    )
  end

  def update_user(id, user_data)
    self.class.put("/api/v1/users/#{id}",
      body: { user: user_data }.to_json,
      headers: @headers
    )
  end

  def delete_user(id)
    self.class.delete("/api/v1/users/#{id}", headers: @headers)
  end

  # Projects
  def get_projects
    self.class.get('/api/v1/projects', headers: @headers)
  end

  def get_project(id)
    self.class.get("/api/v1/projects/#{id}", headers: @headers)
  end

  def create_project(project_data)
    self.class.post('/api/v1/projects',
      body: { project: project_data }.to_json,
      headers: @headers
    )
  end

  def update_project(id, project_data)
    self.class.put("/api/v1/projects/#{id}",
      body: { project: project_data }.to_json,
      headers: @headers
    )
  end

  def delete_project(id)
    self.class.delete("/api/v1/projects/#{id}", headers: @headers)
  end

  # Agent Tasks
  def get_agent_tasks(project_id = nil)
    url = project_id ? "/api/v1/projects/#{project_id}/agent_tasks" : '/api/v1/agent_tasks'
    self.class.get(url, headers: @headers)
  end

  def get_agent_task(project_id, task_id)
    self.class.get("/api/v1/projects/#{project_id}/agent_tasks/#{task_id}", headers: @headers)
  end

  def create_agent_task(project_id, task_data)
    self.class.post("/api/v1/projects/#{project_id}/agent_tasks",
      body: { agent_task: task_data }.to_json,
      headers: @headers
    )
  end

  def update_agent_task(project_id, task_id, task_data)
    self.class.put("/api/v1/projects/#{project_id}/agent_tasks/#{task_id}",
      body: { agent_task: task_data }.to_json,
      headers: @headers
    )
  end

  def execute_agent_task(project_id, task_id)
    self.class.post("/api/v1/projects/#{project_id}/agent_tasks/#{task_id}/execute",
      headers: @headers
    )
  end

  # Artifacts
  def get_artifacts(project_id = nil)
    url = project_id ? "/api/v1/projects/#{project_id}/artifacts" : '/api/v1/artifacts'
    self.class.get(url, headers: @headers)
  end

  def get_artifact(project_id, artifact_id)
    self.class.get("/api/v1/projects/#{project_id}/artifacts/#{artifact_id}", headers: @headers)
  end

  def delete_artifact(project_id, artifact_id)
    self.class.delete("/api/v1/projects/#{project_id}/artifacts/#{artifact_id}", headers: @headers)
  end

  # Crew Configurations
  def get_crew_configurations
    self.class.get('/api/v1/crew_configurations', headers: @headers)
  end

  def get_crew_configuration(id)
    self.class.get("/api/v1/crew_configurations/#{id}", headers: @headers)
  end

  def create_crew_configuration(crew_data)
    self.class.post('/api/v1/crew_configurations',
      body: { crew_configuration: crew_data }.to_json,
      headers: @headers
    )
  end

  def update_crew_configuration(id, crew_data)
    self.class.put("/api/v1/crew_configurations/#{id}",
      body: { crew_configuration: crew_data }.to_json,
      headers: @headers
    )
  end

  def delete_crew_configuration(id)
    self.class.delete("/api/v1/crew_configurations/#{id}", headers: @headers)
  end

  # Crew Executions
  def get_crew_executions(project_id = nil)
    url = project_id ? "/api/v1/projects/#{project_id}/crew_executions" : '/api/v1/crew_executions'
    self.class.get(url, headers: @headers)
  end

  def get_crew_execution(project_id, execution_id)
    self.class.get("/api/v1/projects/#{project_id}/crew_executions/#{execution_id}", headers: @headers)
  end

  def create_crew_execution(project_id, execution_data)
    self.class.post("/api/v1/projects/#{project_id}/crew_executions",
      body: { crew_execution: execution_data }.to_json,
      headers: @headers
    )
  end

  # Workflow Templates
  def get_workflow_templates
    self.class.get('/api/v1/workflow_templates', headers: @headers)
  end

  def get_workflow_template(id)
    self.class.get("/api/v1/workflow_templates/#{id}", headers: @headers)
  end

  def create_workflow_template(template_data)
    self.class.post('/api/v1/workflow_templates',
      body: { workflow_template: template_data }.to_json,
      headers: @headers
    )
  end

  def update_workflow_template(id, template_data)
    self.class.put("/api/v1/workflow_templates/#{id}",
      body: { workflow_template: template_data }.to_json,
      headers: @headers
    )
  end

  def delete_workflow_template(id)
    self.class.delete("/api/v1/workflow_templates/#{id}", headers: @headers)
  end

  # Workflow Executions
  def get_workflow_executions(project_id = nil)
    url = project_id ? "/api/v1/projects/#{project_id}/workflow_executions" : '/api/v1/workflow_executions'
    self.class.get(url, headers: @headers)
  end

  def get_workflow_execution(project_id, execution_id)
    self.class.get("/api/v1/projects/#{project_id}/workflow_executions/#{execution_id}", headers: @headers)
  end

  def create_workflow_execution(project_id, execution_data)
    self.class.post("/api/v1/projects/#{project_id}/workflow_executions",
      body: { workflow_execution: execution_data }.to_json,
      headers: @headers
    )
  end

  def start_workflow_execution(project_id, execution_id)
    self.class.post("/api/v1/projects/#{project_id}/workflow_executions/#{execution_id}/start",
      headers: @headers
    )
  end

  def pause_workflow_execution(project_id, execution_id)
    self.class.post("/api/v1/projects/#{project_id}/workflow_executions/#{execution_id}/pause",
      headers: @headers
    )
  end

  def resume_workflow_execution(project_id, execution_id)
    self.class.post("/api/v1/projects/#{project_id}/workflow_executions/#{execution_id}/resume",
      headers: @headers
    )
  end

  def cancel_workflow_execution(project_id, execution_id)
    self.class.post("/api/v1/projects/#{project_id}/workflow_executions/#{execution_id}/cancel",
      headers: @headers
    )
  end

  private

  def api_client
    @api_client ||= AgentForgeApiClient.new
  end
end