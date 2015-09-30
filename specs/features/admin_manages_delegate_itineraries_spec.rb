require 'rails_helper'

feature 'Admin manages delegate itineraries' do
  let!(:event) { create(:event, name: 'China fair', sdate: '2015-05-11') }
  let!(:supplier) { create(:supplier, an_event: event, firstname: 'John', surname: 'Doe', companyname: 'HP') }
  let!(:supplier1) { create(:supplier, an_event: event, firstname: 'Greg', surname: 'Smith', companyname: 'DELL') }
  let!(:delegate) { create(:delegate, an_event: event) }
  let!(:slot) { create(:slot, an_event: event, type: 'm') }
  let!(:slot1) { create(:slot, an_event: event, stime: 1130, etime: 1300, type: 'm') }
  let!(:slot2) { create(:slot, an_event: event, stime: 1500, etime: 1600, type: 'm') }
  let!(:workshop) { create(:workshop, an_event: event, stime: 1300, etime: 1430) }
  let!(:workshop1) { create(:workshop, an_event: event, stime: 1500, etime: 1630, title: 'Ruby Patterns Workshop') }
  let!(:workshop_attendance) { create(:workshop_attendance, a_delegate: delegate, a_slot: nil, an_event: event, a_workshop: workshop) }
  let!(:workshop_attendance1) { create(:workshop_attendance, a_delegate: delegate, a_slot: nil, an_event: event, a_workshop: workshop1) }
  let!(:appointment) { create(:appointment, a_delegate: delegate, a_supplier: supplier, a_slot: slot, an_event: event) }
  let!(:appointment1) { create(:appointment, a_delegate: delegate, a_supplier: supplier, a_slot: slot1, an_event: event) }
  let!(:appointment2) { create(:appointment, a_delegate: delegate, a_supplier: supplier1, a_slot: slot2, an_event: event) }

  before do
    login_as(FactoryGirl.create(:user))
    click_on 'Events'
    click_on 'China fair'
    click_on 'Itineraries'
    within('.nav.nav-tabs') do
      click_on 'Delegates'
    end
  end

  it 'shows timetable with each slot' do
    click_on delegate.company_name
    expect(page).to have_content("Itinerary for #{delegate.company_name}")
    expect(page).to have_content('11:30')
  end

  it 'shows two day timetable with each slot' do
    create(:slot, an_event: event, day: 2)
    click_on delegate.company_name

    expect(page).to have_content('Monday, May 11, 2015')
    expect(page).to have_content('Tuesday, May 12, 2015')
  end

  it 'shows entries for supplier' do
    appointment1.destroy
    click_on delegate.company_name

    expect(page).to have_content('HP (Mr. John Doe)')
    expect(page).to have_content('Networking / Coffee Break')
    expect(page).to have_content('Krav maga premier')
    expect(page).not_to have_content('DELL (Mr. Greg Smith)')
    expect(page).to have_content('Ruby Patterns Workshop')

    workshop1.destroy

    within('.nav.nav-tabs') do
      click_on 'Delegates'
    end
    click_on delegate.company_name

    expect(page).to have_content('HP (Mr. John Doe)')
    expect(page).to have_content('Networking / Coffee Break')
    expect(page).to have_content('Krav maga premier')
    expect(page).to have_content('DELL (Mr. Greg Smith)')
    expect(page).not_to have_content('Ruby Patterns Workshop')
  end

  it 'shows coffee break when supplier is not assigned' do
    appointment1.destroy
    click_on delegate.company_name
    save_page
    within find('tr', text: '11:30 13:00') do
      expect(page).to have_content('Networking / Coffee Break')
    end
  end

  it 'shows proper title for non meeting slot' do
    create(:slot, an_event: event, stime: 830, etime: 900, type: 'dr', title: 'Registration')
    create(:slot, an_event: event, stime: 900, etime: 1000, type: 's', title: 'Seminar')
    create(:slot, an_event: event, stime: 1000, etime: 1100, type: 'd', title: 'Dinner')
    create(:slot, an_event: event, stime: 1100, etime: 1200, type: 'm', title: 'Meeting')

    click_on delegate.company_name
    within all('table')[0] do
      expect(page).to have_content('Registration')
      expect(page).to have_content('Seminar')
      expect(page).to have_content('Dinner')
      expect(page).not_to have_content('Meeting')
    end
  end

  it 'shows hotel checkout for appointment gap' do
    click_on delegate.company_name
    expect(page).not_to have_content('Hotel Checkout')

    within('.nav.nav-tabs') do
      click_on 'Delegates'
    end

    create(:slot, an_event: event, stime: 1000, etime: 1100, type: 'm')
    click_on delegate.company_name
    expect(page).to have_content('Hotel Checkout', count: 1)

    event.update_attribute(:hotel_checkout_time, 1030)
    appointment.destroy
    within('.nav.nav-tabs') do
      click_on 'Delegates'
    end
    click_on delegate.company_name

    expect(page).to have_content('Hotel Checkout', count: 1)
    expect(page).to have_content('Networking / Coffee Break', count: 1)

    event.update_attribute(:hotel_checkout_time, 1100)
    within('.nav.nav-tabs') do
      click_on 'Delegates'
    end
    click_on delegate.company_name

    expect(page).to have_content('Hotel Checkout', count: 1)
    expect(page).not_to have_content('Networking / Coffee Break', count: 2)
  end
end
