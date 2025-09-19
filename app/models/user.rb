class User
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Serialization

  attribute :id, :integer
  attribute :email, :string
  attribute :first_name, :string
  attribute :last_name, :string
  attribute :openai_api_key, :string
  attribute :anthropic_api_key, :string
  attribute :atlassian_domain, :string
  attribute :atlassian_api_token, :string
  attribute :atlassian_user_email, :string
  attribute :atlassian_account_id, :string
  attribute :github_token, :string
  attribute :github_username, :string
  attribute :crewai_api_key, :string
  attribute :created_at, :datetime
  attribute :updated_at, :datetime

  def self.all
    response = api_client.get_users
    return [] unless response.success?

    response.parsed_response.map { |user_data| new(user_data) }
  end

  def self.find(id)
    response = api_client.get_user(id)
    return nil unless response.success?

    new(response.parsed_response)
  end

  def self.create(attributes)
    user = new(attributes)
    user.save
    user
  end

  def save
    if id.present?
      response = api_client.update_user(id, attributes.except('id'))
    else
      response = api_client.create_user(attributes.except('id'))
    end

    if response.success?
      data = response.parsed_response
      self.id = data['id'] if data['id']
      true
    else
      false
    end
  end

  def destroy
    return false unless id.present?

    response = api_client.delete_user(id)
    response.success?
  end

  def persisted?
    id.present?
  end

  def full_name
    "#{first_name} #{last_name}".strip
  end

  private

  def self.api_client
    @api_client ||= AgentForgeApiClient.new
  end

  def api_client
    self.class.api_client
  end
end