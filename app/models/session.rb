class Session
  include ActiveModel::Model

  attr_accessor :email, :password

  validates :email, presence: true
  validates :password, presence: true

  validate do |session|
    errors.add :base, I18n.t('activerecord.errors.models.session.invalid') unless email.blank? || password.blank? || session.authenticate
  end

  def id
    user&.id
  end

  def id=(v)
    self.user = User.find_by id: v
  end

  def user
    User.find_by email: email
  end

  def user=(v)
    self.email = v&.email
  end

  def authenticate
    if user&.authenticate password
      self.password = nil
      return true
    else
      return false
    end
  end

  def save
    if validate
      self.class.current = self
      return true
    else
      return false
    end
  end

  def destroy
    self.class.current = nil
  end

  def persisted?
    self.class.current == self
  end
  alias_method :exists?, :persisted?

  def ==(session)
    session.is_a?(self.class) && id.present? && id == session.id
  end

  class << self
    KEY = :user_id

    attr_accessor :store

    def current
      new id: store&.[](KEY)
    end

    def current=(v)
      store&.[]=(KEY, v&.id)
    end

    def columns
      [
        Struct.new(:name, :type).new('email', :string),
        Struct.new(:name, :type).new('password', :string)
      ]
    end
  end
end
