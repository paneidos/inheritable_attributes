# InheritableAttributes
module InheritableAttributes
  module ClassMethods
    def inherit_attribute(attribute, options = {})
      raise ArgumentError.new("must specify :from") unless options[:from]
      parent = options[:from]
      parent_attribute = options[:as] || attribute


      if instance_methods.include? "#{attribute}"
        define_method "#{attribute}_with_inheritance" do
          val = send("#{attribute}_without_inheritance")
          if val.nil? && !parent.nil?
            send(parent).send(parent_attribute)
          else
            val
          end
        end
        alias_method_chain attribute, :inheritance
      else
        define_method "#{attribute}" do
          if !parent.nil?
            send(parent).send(parent_attribute)
          else
            nil
          end
        end
      end
    end

    def inherit_attributes(attributes, options = {})
      options[:as] = nil
      [attributes].flatten.each do |attribute|
        inherit_attribute attribute,options
      end
    end
  end

  def self.included(receiver)
    receiver.extend         ClassMethods
  end
end