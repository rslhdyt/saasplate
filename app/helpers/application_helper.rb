module ApplicationHelper
  def current_active_company
    Rails.cache.fetch("current_active_company:#{current_user.id}", skip_nil: true, expires_in: 1.hour) do
      current_user.active_company
    end
  end

  def app_date(date, format = '%d/%m/%Y')
    return if date.nil?

    date = Date.parse(date) if date.is_a?(String)

    date.strftime(format)
  end

  # rubocop:disable Metrics/ParameterLists
  def app_currency(value, unit = 'Rp ', separator = ',', delimiter = '.', precision = 2)
    return if value.nil?

    number_to_currency(value, unit: unit, separator: separator, delimiter: delimiter, precision: precision)
  end
  # rubocop:enable Metrics/ParameterLists
end
