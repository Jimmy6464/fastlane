describe IosDeployKit do
  describe IosDeployKit::App do
    let (:apple_id) { 284882215 }
    let (:app_identifier) { 'com.facebook.Facebook' }

    describe "#initialize" do
      it "automatically fetches the app identifier, if only Apple ID is given" do
        app = IosDeployKit::App.new(apple_id: apple_id)

        expect(app.app_identifier).to eq(app_identifier)
        expect(app.apple_id).to eq(apple_id)
      end

      it "lets me create an app using an Apple ID and app identifier" do
        app = IosDeployKit::App.new(apple_id: apple_id, 
                              app_identifier: app_identifier)

        expect(app.app_identifier).to eq(app_identifier)
        expect(app.apple_id).to eq(apple_id)
      end

      it "lets me create an app without any information given (yet)" do
        expect(IosDeployKit::App.new.app_identifier).to eq(nil)
      end
    end


    describe "Accessing App Metadata", felix: true do
      let (:apple_id) { 794902327 }
      before do
        @app = IosDeployKit::App.new(apple_id: apple_id, app_identifier: 'net.sunapps.1')
      end

      describe "#set_metadata_directory" do

        it "throws an exception when updating the location after accessing metadata" do
          @app.metadata = IosDeployKit::AppMetadata.new(@app, "./spec/fixtures/example1.itmsp/", false)
          expect {
            @app.set_metadata_directory("something")
          }.to raise_error("Can not change metadata directory after accessing metadata of an app")
        end

        it "let's the user modify the download directory" do
          expect(@app.get_metadata_directory).to eq("./")

          alternative = '/tmp/'
          @app.set_metadata_directory(alternative)

          expect(@app.get_metadata_directory).to eq(alternative)
        end

      end

      describe "#upload_metadata!" do
        it "throws an exception when metadata was not yet downloaded" do
          expect { 
            @app.upload_metadata!
          }.to raise_error("You first have to modify the metadata using app.metadata.setDescription")
        end
      end
    end
  end
end