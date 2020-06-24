# frozen_string_literal: true

def ids
  id_file = YAML.load_file('features/support/massa/id.yml')
  id_file['ids']
end
