require 'spec_helper'
require 'restool/traversal/converter'

describe Restool::Traversal::Converter do

  describe '.convert' do
    let(:request_response) do
      {
        first_name: 'Homer', last_name: 'Simpson',
        address: { number: 742, street: 'Evergreen Terrace' }
      }
    end

    let(:response_representation) do
      FactoryBot.build(
        :operation_response,
        fields: [
          FactoryBot.build(:representation_field,
                           key: :first_name, metonym: :name, type: :string),
          FactoryBot.build(:representation_field,
                           key: :last_name, metonym: :surname, type: :string),
          FactoryBot.build(:representation_field,
                           key: :address, metonym: :address, type: :address)
        ]
      )
    end

    let(:address_representation) do
      FactoryBot.build(
        :representation,
        name: :address,
        fields: [
          FactoryBot.build(:representation_field,
                           key: :street, metonym: :street, type: :string),
          FactoryBot.build(:representation_field,
                           key: :number, metonym: :number, type: :integer)
        ]
      )
    end
    let(:representations) { { address: address_representation } }

    subject do
      Restool::Traversal::Converter.convert(request_response, response_representation,
                                           representations)
    end

    its(:name) { is_expected.to eq('Homer') }
    its(:surname) { is_expected.to eq('Simpson') }
    its('address.number') { is_expected.to eq(742) }
    its('address.street') { is_expected.to eq('Evergreen Terrace') }

    its(:_raw) { is_expected.to eq(request_response) }

    context 'when the request response has string keys' do
      let(:request_response) do
        {
          'first_name' => 'Homer', 'last_name' => 'Simpson',
          address: { number: 742, street: 'Evergreen Terrace' }
        }
      end

      its(:name) { is_expected.to eq('Homer') }
      its(:surname) { is_expected.to eq('Simpson') }
      its('address.number') { is_expected.to eq(742) }
      its('address.street') { is_expected.to eq('Evergreen Terrace') }

      its(:_raw) { is_expected.to eq(request_response) }
    end

    context 'when a metonym is not defined for a field key' do
      let(:response_representation) do
        FactoryBot.build(
          :operation_response,
          fields: [
            FactoryBot.build(:representation_field,
                             key: :first_name, metonym: nil, type: :string),
            FactoryBot.build(:representation_field,
                             key: :last_name, metonym: nil, type: :string),
            FactoryBot.build(:representation_field,
                             key: :address, metonym: :address, type: :address)
          ]
        )
      end

      its(:first_name) { is_expected.to eq('Homer') }
      its(:last_name) { is_expected.to eq('Simpson') }
    end

    context 'when the response in an array' do
      let(:request_response) do
        [{
          first_name: 'Homer', last_name: 'Simpson',
          address: { number: 742, street: 'Evergreen Terrace' }
        }] * rand(1..10)
      end

      it 'converts every element of the response' do
        subject.each do |element|
          expect(element.name).to eq('Homer')
          expect(element.surname).to eq('Simpson')
          expect(element.address.number).to eq(742)
          expect(element.address.street).to eq('Evergreen Terrace')
        end
      end
    end

    context 'when the response is empty' do
      let(:request_response) { [] }

      it { is_expected.to eq([]) }
    end

    context 'when the key is missing in the response' do
      let(:request_response) do
        {
          first_name: 'Homer', address: { street: 'Evergreen Terrace' }
        }
      end

      its(:surname) { is_expected.to be_nil }
      its('address.number') { is_expected.to be_nil }
    end
  end
end
