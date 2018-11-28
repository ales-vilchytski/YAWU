require "json-schema"

class JS::Schema

  def validate(json, schema)
    res = JSON::Validator.fully_validate(schema, json, :validate_schema => true)
    if res == []
      'OK'
    else
      JSON.dump(res, indent=2)
    end
  end

end

