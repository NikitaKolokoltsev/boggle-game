def json(response_body)
  JSON.parse(response_body).with_indifferent_access
end