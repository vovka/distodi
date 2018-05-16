require "spec_helper"

describe ImportTranslations do
  class ModelMock
    def transaction(&block); yield end
    def find_or_create_by!(*args); end
  end

  class SimpleBackendMock < Struct.new(:translations)
    def load_translations; end
  end

  describe "#perform" do
    it "stores translations from simple_backend using model" do
      model = ModelMock.new
      allow(model).to receive(:find_or_create_by!)
      import = ImportTranslations.new(model: model)
      allow(import).to receive(:read_files).and_return([{
        zz: { lorem: { ipsum: "dolor sit amet" }}
      }])

      import.perform

      expect(model).to have_received(:find_or_create_by!).with({
        locale: "zz",
        key: "lorem.ipsum",
        value: "dolor sit amet"
      })
    end
  end
end
