# Agent Forge Admin

A comprehensive Rails admin interface using Active Admin to manage data from the Agent Forge API system. This admin panel provides a user-friendly interface for managing users, projects, agent tasks, crew configurations, and more.

## Features

### 🎛️ **Admin Dashboard**
- Real-time statistics and system health monitoring
- Quick action buttons for common tasks
- Recent activity tracking
- API connectivity status

### 👥 **User Management**
- Manage user accounts and profiles
- Configure API keys (OpenAI, Anthropic, CrewAI, GitHub)
- Set up Atlassian and GitHub integrations
- View user activity and projects

### 📊 **Project Management**
- Create and manage projects
- Track project progress and status
- Configure technology stacks
- Set up repository and Atlassian integrations
- View project statistics and related items

### 🤖 **Agent Task Management**
- Create and assign tasks to different agent types
- Execute tasks directly from the admin interface
- Monitor task status and progress
- View task input/output data and error logs
- Batch operations for multiple tasks

### 👨‍💻 **Crew Configuration Management**
- Configure and manage CrewAI crews
- Set up agents with roles, goals, and backstories
- Activate/deactivate crew configurations
- View execution history and statistics

### 🔗 **API Integration**
- Seamless integration with Agent Forge API
- Real-time data synchronization
- RESTful API client with error handling
- Support for all Agent Forge API endpoints

## Technology Stack

- **Framework**: Ruby on Rails 7.2
- **Admin Interface**: Active Admin
- **Authentication**: Devise
- **Database**: PostgreSQL
- **HTTP Client**: HTTParty
- **UI Components**: Active Admin with custom styling

## Setup Instructions

### Prerequisites

- Ruby 3.1.0 or higher
- PostgreSQL
- Agent Forge API running (default: http://localhost:3002)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/YourUsername/agent_forge_admin.git
   cd agent_forge_admin
   ```

2. **Install dependencies**
   ```bash
   bundle install
   ```

3. **Configure database**
   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   ```

4. **Set environment variables**
   ```bash
   # .env file or system environment
   export AGENT_FORGE_API_URL=http://localhost:3002
   ```

5. **Start the server**
   ```bash
   rails server -p 3001
   ```

6. **Access the admin interface**
   - Navigate to: http://localhost:3001/admin
   - Default admin credentials:
     - Email: admin@example.com
     - Password: password

## Configuration

### Environment Variables

- `AGENT_FORGE_API_URL`: URL of the Agent Forge API (default: http://localhost:3002)
- `DATABASE_URL`: PostgreSQL database connection string
- `RAILS_ENV`: Rails environment (development, production, etc.)

### Agent Forge API Integration

The admin interface communicates with your Agent Forge API through the `AgentForgeApiClient` service. Ensure your API is running and accessible at the configured URL.

## Usage

### Managing Users
1. Navigate to "Users" in the admin menu
2. Create new users with email and personal information
3. Configure API keys for various services
4. Set up integration credentials for GitHub and Atlassian

### Managing Projects
1. Go to "Projects" section
2. Create projects with descriptions and technology stacks
3. Configure repository and workspace integrations
4. Monitor progress and view statistics

### Managing Agent Tasks
1. Access "Agent Tasks" from the menu
2. Create tasks for specific agent types
3. Execute tasks directly from the interface
4. Monitor execution status and view results

### Managing Crew Configurations
1. Navigate to "Crew Configurations"
2. Create and configure CrewAI crews
3. Define agents with roles and capabilities
4. Activate crews for use in projects

## API Client

The `AgentForgeApiClient` service provides a complete interface to the Agent Forge API:

```ruby
# Initialize client
client = AgentForgeApiClient.new

# Fetch all projects
projects = client.get_projects

# Create a new user
user_data = { email: 'user@example.com', first_name: 'John', last_name: 'Doe' }
client.create_user(user_data)

# Execute an agent task
client.execute_agent_task(project_id, task_id)
```

## Active Admin Customization

The admin interface includes custom:
- Dashboard with real-time statistics
- Batch actions for bulk operations
- Custom member actions (execute, toggle status)
- Rich form inputs with hints and validation
- Filtered views and search functionality

## Development

### Adding New Models

1. Create the model in `app/models/`
2. Add API client methods in `AgentForgeApiClient`
3. Create the admin interface in `app/admin/`
4. Update the dashboard if needed

### Customizing the Interface

- Modify `app/admin/dashboard.rb` for dashboard changes
- Update individual admin files for specific model interfaces
- Add custom CSS in `app/assets/stylesheets/active_admin.scss`

## Production Deployment

1. **Set production environment variables**
2. **Configure production database**
3. **Precompile assets**: `rails assets:precompile`
4. **Run migrations**: `rails db:migrate RAILS_ENV=production`
5. **Start server**: `rails server -e production`

## Security Considerations

- API keys are partially masked in the interface
- Admin authentication required for all operations
- API client handles token-based authentication
- Input validation and sanitization
- CSRF protection enabled

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## Support

For issues and questions:
- Check the Agent Forge API documentation
- Review Active Admin documentation
- Create an issue in this repository

## License

This project is licensed under the MIT License.
