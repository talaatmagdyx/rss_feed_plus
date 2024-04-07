require_relative '../../lib/rss_feed/dynamic_object'

RSpec.describe DynamicObject do
  describe '#initialize' do
    context 'with nested hashes' do
      it 'initializes with correct attributes', :only do
        data = { name: 'John', age: 30, address: { city: 'New York', state: 'NY' } }
        dynamic_object = described_class.new(data)

        expect(dynamic_object.name).to eq('John')

      end

      it 'initializes with correct attributes # age', :only do
        data = { name: 'John', age: 30, address: { city: 'New York', state: 'NY' } }
        dynamic_object = described_class.new(data)
        expect(dynamic_object.age).to eq(30)
      end

      it 'initializes with correct attributes # city', :only do
        data = { name: 'John', age: 30, address: { city: 'New York', state: 'NY' } }
        dynamic_object = described_class.new(data)
        expect(dynamic_object.address.city).to eq('New York')
      end

      it 'initializes with correct attributes # state', :only do
        data = { name: 'John', age: 30, address: { city: 'New York', state: 'NY' } }
        dynamic_object = described_class.new(data)
        expect(dynamic_object.address.state).to eq('NY')
      end
    end

    context 'with arrays' do
      it 'initializes with correct attributes', :only do
        data = { hobbies: %w[reading hiking] }
        dynamic_object = described_class.new(data)

        expect(dynamic_object.hobbies).to eq(%w[reading hiking])
      end
    end
  end

  describe '#define_singleton_method' do
    context 'when accessing dynamically defined methods' do
      it 'allows accessing attributes dynamically', :only do
        data = { name: 'Alice' }
        dynamic_object = described_class.new(data)

        expect(dynamic_object.name).to eq('Alice')
      end
    end
  end
end
