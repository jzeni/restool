require 'spec_helper'
require 'restool'

describe Restool do

  describe '.create' do
    let(:mock_service) { YAML.load_file('config/github.sample.yml') }
    let(:mock_service_operation_names) do
      ['get_repos']
    end
    let(:mock_service_url) { 'https://api.github.com/users/1/repos' }
    let(:restool_service) do
      Restool.create(:github_api) do |response, code|
        JSON(response)['data']
      end
    end

    subject { restool_service }

    before do
      allow(File).to receive(:exist?).and_call_original
      allow(File).to receive(:exist?).with('config/restool.yml').and_return(true)
      allow(YAML).to receive(:load_file).and_return(mock_service)
    end

    it { is_expected.to be_a(Restool::Service::RestoolService) }

    it 'defines a method for each operation' do
      is_expected.to respond_to(*mock_service_operation_names)
    end

    describe 'an operation response' do
      let(:uri_params) { [1] }
      let(:params) { {} }
      let(:operation_name) { :get_repos }
      let(:operation_response) do
        {
          data: [{
            id: 45,
            full_name: 'Homer Jay Simpson',
            owner: {
              login: 'homer.dev',
              url: 'http://homer.dev'
            }
          }]
        }.to_json
      end

      subject { restool_service.send(operation_name, uri_params, params) }

      before do
        stub_request(:any, mock_service_url)
          .to_return(body: operation_response)
      end

      its('first.identifier') { is_expected.to eq(45) }
      its('first.full_name') { is_expected.to eq('Homer Jay Simpson') }
      its('first.owner.username') { is_expected.to eq('homer.dev') }

      context 'when the operation times out' do
        before do
          stub_request(:any, mock_service_url)
            .to_timeout
        end

        it { expect { subject }.to raise_error(Net::OpenTimeout) }
      end
    end

  end

end
