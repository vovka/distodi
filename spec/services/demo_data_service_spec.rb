require "spec_helper"

describe DemoDataService do
  describe "#perform" do
    before :each do
      user = create :user
      @category = create :category, name: "Some test category"
      @object_under_test = DemoDataService.new user
      file = File.open(Rails.root.join("spec/fixtures/an_image.jpg"))
      allow(@object_under_test).to receive(:picture_for).and_return(file)
      allow(I18n).to receive(:t)
    end

    let(:category) { @category }
    let(:object_under_test) { @object_under_test }

    describe "creates demo item" do
      before :each do
        allow(object_under_test).to receive(:services_amount).and_return(0)
      end

      let(:item) { object_under_test.perform[0] }

      specify "with demo field true" do
        expect(item.demo).to be(true)
      end

      specify "with category" do
        expect(item.category).to eq(category)
      end

      specify "with file" do
        expect(item.picture.filename).to eq("an_image.jpg")
      end

      it "with title from translation" do
        allow(I18n).to receive(:t)
          .with("service_objects.demo_data_service.item.some_test_category.title", *anything)
          .and_return(%w(q w e))

        expect(item.title).to be_in(%w(q w e))
      end

      it "with comment from translation" do
        allow(I18n).to receive(:t)
          .with("service_objects.demo_data_service.item.some_test_category.comment", *anything)
          .and_return(%w(a s d))

        expect(item.comment).to be_in(%w(a s d))
      end

      it "with characteristic (brand) from translation" do
        category.attribute_kinds.brand.create!
        allow(I18n).to receive(:t)
          .with("service_objects.demo_data_service.item.some_test_category.brand", *anything)
          .and_return(%w(z x c))

        expect(item.characteristics.brand.first.value).to be_in(%w(z x c))
      end

      it "without characteristic (brand) when there is no values set in translation" do
        expect(item.characteristics.brand).to be_empty
      end
    end

    describe "creates demo services" do
      before :each do
        create :service_kind, categories: [category]
        create :action_kind, title: "Control", categories: [category]
        create :action_kind, title: "Tuning", categories: [category]
        create :action_kind, title: "Change", categories: [category]
        create :company, demo: true, name: "The Company"
        allow(I18n).to receive(:t)
          .with("service_objects.demo_data_service.service.some_test_category.control.company_name", *anything)
          .and_return("The Company")
        allow(I18n).to receive(:t)
          .with("service_objects.demo_data_service.service.some_test_category.tuning.company_name", *anything)
          .and_return("The Company")
        allow(I18n).to receive(:t)
          .with("service_objects.demo_data_service.service.some_test_category.change.company_name", *anything)
          .and_return("The Company")

        _, @services = object_under_test.perform
      end

      let(:services) { @services.select(&:demo?) }

      specify "at least one pending" do
        expect(services.find(&:pending?)).to be_present
      end

      specify "at least one approved" do
        expect(services.find(&:approved?)).to be_present
      end

      specify "at least one declined" do
        expect(services.find(&:declined?)).to be_present
      end

      describe "among pending" do
        let(:pending_services) { services.select(&:pending?) }

        specify "at least one control" do
          service = pending_services.find do |s|
            s.action_kinds.pluck(:title) == ["Control"]
          end

          expect(service).to be_present
        end

        specify "at least one tuning" do
          service = pending_services.find do |s|
            s.action_kinds.pluck(:title) == ["Tuning"]
          end

          expect(service).to be_present
        end

        specify "at least one change" do
          service = pending_services.find do |s|
            s.action_kinds.pluck(:title) == ["Change"]
          end

          expect(service).to be_present
        end
      end

      describe "among approved" do
        let(:pending_services) { services.select(&:approved?) }

        specify "at least one control" do
          service = pending_services.find do |s|
            s.action_kinds.pluck(:title) == ["Control"]
          end

          expect(service).to be_present
        end

        specify "at least one tuning" do
          service = pending_services.find do |s|
            s.action_kinds.pluck(:title) == ["Tuning"]
          end

          expect(service).to be_present
        end

        specify "at least one change" do
          service = pending_services.find do |s|
            s.action_kinds.pluck(:title) == ["Change"]
          end

          expect(service).to be_present
        end
      end

      describe "among declined" do
        let(:pending_services) { services.select(&:declined?) }

        specify "at least one control" do
          service = pending_services.find do |s|
            s.action_kinds.pluck(:title) == ["Control"]
          end

          expect(service).to be_present
        end

        specify "at least one tuning" do
          service = pending_services.find do |s|
            s.action_kinds.pluck(:title) == ["Tuning"]
          end

          expect(service).to be_present
        end

        specify "at least one change" do
          service = pending_services.find do |s|
            s.action_kinds.pluck(:title) == ["Change"]
          end

          expect(service).to be_present
        end
      end
    end

    describe "creates demo services" do
      before :each do
        allow(object_under_test).to receive(:services_amount).and_return(1)

        create :service_kind, categories: [category]
        create :action_kind, title: "Control", categories: [category]
        create :company, demo: true, name: "The Company"
      end

      it "with reason when rejected" do
        allow(object_under_test).to receive(:next_status)
          .and_return(Service::STATUS_DECLINED)
        allow(I18n).to receive(:t)
          .with("service_objects.demo_data_service.service.some_test_category.decline_reason", *anything)
          .and_return(%w(q w e))

        _, services = object_under_test.perform

        expect(services.first.reason).to be_in(%w(q w e))
      end

      it "with approver company wen it is specified in translations for the action kind" do
        allow(I18n).to receive(:t)
          .with("service_objects.demo_data_service.service.some_test_category.control.company_name", *anything)
          .and_return(["The Company"])

        _, services = object_under_test.perform

        expect(services.first.approver).to eq(Company.demo.find_by_name("The Company"))
      end

      it "self approvable when approver company isn't specified in translations for the action kind" do
        _, services = object_under_test.perform

        expect(services.first).to be_self_approvable
      end
    end
  end
end
