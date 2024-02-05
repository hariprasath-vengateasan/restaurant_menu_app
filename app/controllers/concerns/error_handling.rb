# app/controllers/concerns/error_handling.rb
module ErrorHandling
  def handle_record_invalid(exception)
    {
      success: false,
      errors: exception.record.errors.full_messages
    }
  end

  def handle_record_not_found(exception)
    {
      success: false,
      errors: {
        message: 'The requested records are not relevant. Please check the provided parameters.',
        error: "Error: #{exception.message}"
      }
    }
  end

  def handle_standard_error(exception)
    {
      success: false,
      errors: {
        message: 'Something went wrong. Please try again later',
        error: "Error: #{exception.message}"
      }
    }
  end

  def error_message(message)
    {
      success: false,
      errors: message
    }
  end

  def handle_exception(exception)
    if exception.is_a?(ActiveRecord::RecordInvalid)
      handle_record_invalid(exception)
    elsif exception.is_a?(ActiveRecord::RecordNotFound)
      handle_record_not_found(exception)
    else
      handle_standard_error(exception)
    end
  end
end
