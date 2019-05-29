require 'spec_helper'
require 'restool/service/uri_utils'

describe Restool::Service::UriUtils do

  describe '.build_path' do
    let(:path) { '/resource_name/:id' }
    let(:uri_params) { nil }
    let(:operation) do
      FactoryBot.build(:operation, path: path, uri_params: uri_params)
    end

    subject do
      Restool::Service::UriUtils.build_path(operation)
    end

    it { is_expected.to eq(path) }

    context 'when the path is empty' do
      let(:path) { '' }

      it { is_expected.to eq('') }
    end

    context 'when the path is only a slash' do
      let(:path) { '/' }

      it { is_expected.to eq('/') }
    end

    context 'when there are uri params values' do
      let(:uri_params_values) { [24] }
      let(:uri_params) { [':id'] }

      subject do
        Restool::Service::UriUtils.build_path(operation, uri_params_values)
      end

      it { is_expected.to eq('/resource_name/24') }

      context 'with multiple uri params' do
        let(:path) { '/resource_name/:id/:pepe' }
        let(:uri_params) { [':id', ':pepe'] }
        let(:uri_params_values) { [24, 'hola'] }

        it { is_expected.to eq('/resource_name/24/hola') }
      end

    end
  end
end
