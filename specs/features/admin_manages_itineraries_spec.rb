require 'rails_helper'

feature "Admin manages itineraries" do
  let!(:event) { create(:event, name: "China fair") }
  let!(:supplier) { create(:supplier, an_event: event) }
  let!(:delegate) { create(:delegate, an_event: event) }
  let!(:slot) { create(:slot, an_event: event) }

  before do
    login_as(FactoryGirl.create(:user))

    click_on 'Events'
    click_on 'China fair'

  end

  scenario 'admin can calculate itineraries' do
    click_on 'Itineraries'
    expect(page).to have_content('Calculate itineraries')
  end

  scenario 'admin can recalculate itineraries' do
    create(:appointment, a_delegate: delegate, a_supplier: supplier, a_slot: slot, an_event: event)
    click_on 'Itineraries'

    expect(page).to have_content('Recalculate itineraries')
  end


  scenario 'admin has supplier list' do
    create(:appointment, a_delegate: delegate, a_supplier: supplier, a_slot: slot, an_event: event)

    click_on 'Itineraries'

    within('.nav.nav-tabs') do
      click_on 'Suppliers'
    end

    expect(page).to have_content(supplier.company_name)
    expect(page).to have_content(supplier.reps)
  end
end
