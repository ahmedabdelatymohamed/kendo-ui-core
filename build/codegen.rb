require 'codegen/lib/options'
require 'codegen/lib/markdown_parser'
require 'codegen/lib/component'
require 'codegen/lib/java/module'
require 'codegen/lib/java/composite_option'
require 'codegen/lib/java/event'
require 'codegen/lib/java/option'
require 'codegen/lib/java/component'
require 'codegen/lib/java/tld'
require 'codegen/lib/java/jsp'
require 'codegen/lib/java/api'

namespace :generate do

    task :java => ['java:tld', 'java:jsp']

    namespace :java do

        def import_metadata(component)
            metadata = "build/codegen/#{component.name.downcase}.yml"

            if File.exists?(metadata)
                yaml = YAML.load(File.read(metadata))

                component.import(yaml)
            end
        end

        task :jsp do

            components = CodeGen::MarkdownParser.all(CodeGen::Java::JSP::Component)

            components.each do |component|

                import_metadata(component)

                generator = CodeGen::Java::JSP::Generator.new('wrappers/java/kendo-taglib/src/main/java/com/kendoui/taglib/')

                generator.component(component)

            end

        end

        task :api do

            components = CodeGen::MarkdownParser.all(CodeGen::Java::API::Component)

            components.each do |component|

                import_metadata(component)

                generator = CodeGen::Java::API::Generator.new('docs/api/wrappers/jsp/')

                generator.component(component)

            end

        end

        task :tld do

            generator = CodeGen::Java::TLD::Generator.new('wrappers/java/kendo-taglib/src/main/resources/META-INF/taglib.tld')

            components = CodeGen::MarkdownParser.all(CodeGen::Java::TLD::Component)

            components.each do |component|

                import_metadata(component)

                generator.component(component)

            end

            generator.sync

        end
    end

end
