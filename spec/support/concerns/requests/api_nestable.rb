shared_examples_for 'API Nestable' do |nest_name|
  # let!("#{nest_name}s") { create_list nest_name.to_sym, send("#{nest_name}s_list_size"), "#{nest_name}able".to_sym => send("#{nest_name}able") }
  let("received_#{nest_name}s") { send("received_#{nest_name}able")["#{nest_name}s"] }

  it_behaves_like 'API Listable' do
    let(:list_name) { "#{nest_name}s" }
  end

  it_behaves_like 'API Fieldable' do
    let(:fieldable) { send("#{nest_name}s").first }
    let(:received_fieldable) { send("received_#{nest_name}s").first }
  end
end
