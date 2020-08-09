module ApplicationHelper
    def translate_attribute(object = nil, method = nil)
        (object && method) ? object.model.human_attribute_name(method) : "Informer os parâmetros corretamente !!"
    end
end
