class ApplicationService
  def self.call(...)
    new(...).call
  end

  # :nocov:
  def call
    raise NoMethodError
  end
end
