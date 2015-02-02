module Spark
  # Extension cannot be built
  class BuildError < StandardError
  end

  # Proc.to_source
  class SerializeError < StandardError
  end

  # Serializer method
  # Non-existing serializer
  class NotImplemented < StandardError
  end

  # Missison app_name or master
  class ConfigurationError < StandardError
  end

  # Wrong parameters
  class RDDError < StandardError
  end

  # Validations
  class CommandError < StandardError
  end

  # Parser helper
  class ParseError < StandardError
  end

  # Validation in context
  class ContextError < StandardError
  end

  # Broadcasts
  # Existing keys
  # Wrong ID
  class BroadcastError < StandardError
  end

  # Accumulators
  # Existing keys
  # Wrong ID
  class AccumulatorError < StandardError
  end
end
