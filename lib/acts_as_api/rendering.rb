module ActsAsApi

  # The methods of this module are included into the AbstractController::Rendering
  # module.
  module Rendering

    # Provides an alternative to the +render+ method used within the controller
    # to simply generate API outputs.
    #
    # The default Rails serializers are used to serialize the data.
    def render_for_api(render_options)

      # extract the api format and model
      api_format_options = {}

      ActsAsApi::ACCEPTED_API_FORMATS.each do |item|
        if render_options.has_key?(item)
          api_format_options[item] = render_options[item]
          render_options.delete item
        end
      end


      api_format =  api_format_options.keys.first
      api_model =  api_format_options.values.first

      # set the params to render
      output_params = render_options

      # set the name of the root node - pluralize for arrays
      api_root_name = api_model.is_a?(Array) ? api_model.first.class.name.downcase.pluralize : api_model.class.name.downcase
      output_params[:root] = api_root_name

      # create the Hash as response
      output_params[api_format] = api_model.as_api_response

      render output_params

    end

  end
  
end