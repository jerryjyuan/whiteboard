require 'spec_helper'

describe "items", type: :request, js: true do
  let!(:standup) { FactoryGirl.create(:standup, title: 'San Francisco', subject_prefix: "[Standup][SF]", closing_message: 'Woohoo') }
  let!(:other_standup) { FactoryGirl.create(:standup, title: 'New York') }

  before do
    utc_today = Time.now
    utc_tomorrow = utc_today + 1.day
    utc_five_days = utc_today + 5.days

    login
    visit '/'
    click_link(standup.title)

    find('a[data-kind="New face"] i').click
    fill_in 'item_title', :with => "Fred Flintstone"
    select 'New York', :from => 'item[standup_id]'
    click_button 'Create New Face'

    find('a[data-kind="New face"] i').click
    fill_in 'item_title', :with => "Johnathon McKenzie"
    select 'San Francisco', from: 'item[standup_id]'
    click_button 'Create New Face'

    find('a[data-kind="New face"] i').click
    fill_in 'item_title', :with => "Jane Doe"
    fill_in 'item_date', :with => (Time.now + 5.days).to_date.strftime("%Y-%m-%d")
    select 'San Francisco', from: 'item[standup_id]'
    click_button 'Create New Face'

    find('a[data-kind="Event"] i').click
    fill_in 'item_title', :with => "Meetup"
    fill_in 'item_date', :with => utc_five_days.to_date.strftime("%Y-%m-%d")
    select 'New York', from: 'item[standup_id]'
    click_button 'Create Item'

    find('a[data-kind="Event"] i').click
    fill_in 'item_title', :with => "Party"
    fill_in 'item_date', :with => utc_five_days.to_date.strftime("%Y-%m-%d")
    select 'San Francisco', from: 'item[standup_id]'
    click_button 'Create Item'

    find('a[data-kind="Event"] i').click
    fill_in 'item_title', :with => "Happy Hour"
    fill_in 'item_date', :with => utc_today.localtime.to_date.strftime("%Y-%m-%d")
    select 'San Francisco', from: 'item[standup_id]'
    click_button 'Create Item'

    find('a[data-kind="Event"] i').click
    fill_in 'item_title', :with => "Baseball"
    fill_in 'item_date', :with => utc_tomorrow.localtime.to_date.strftime("%Y-%m-%d")
    select 'San Francisco', from: 'item[standup_id]'
    click_button 'Create Item'

    find('a[data-kind="Interesting"] i').click
    fill_in 'item_title', :with => "Linux 3.2 out"
    fill_in 'item_author', :with => "Linus Torvalds"
    fill_in 'item_description', with: "Check it out!"
    click_button 'Create Item'

    find('a[data-kind="Event"] i').click
    click_button('Interesting')
    fill_in 'item_title', :with => "Rails 62 is out"
    fill_in 'item_author', :with => "DHH"
    fill_in 'item_description', with: "Now with more f-bombs"
    click_button 'Create Item'
  end

  it 'deck.js for standup' do
    visit '/'
    click_link(standup.title)

    page.should have_css('.subheader.today', text: 'Today')

    within '.event' do
      page.should have_css('.today + .item', text: 'Happy Hour')
      page.should have_css('.subheader.tomorrow', text: 'Tomorrow')
      page.should have_css('.tomorrow + .item', text: 'Baseball')
      page.should have_css('.subheader.upcoming', text: 'Upcoming')
      page.should have_css('.upcoming + .item', text: 'Party')
    end

    within '.kind.new_face' do
      page.should have_css('.subheader.today', text: 'Today')
      page.should have_css('.today + .item', text: 'Johnathon McKenzie')
      page.should have_css('.subheader.upcoming', text: 'Upcoming')
      page.should have_css('.upcoming + .item', text: 'Jane Doe')
    end

    visit presentation_standup_items_path(standup)

    within 'section.deck-current' do
      page.should have_content "Standup"
      page.should have_css('.countdown')
    end
    page.execute_script("$.deck('next')")

    within 'section.deck-current' do
      page.should have_content "New faces"
      page.should have_content "Today"
      page.should have_content "Upcoming"
      page.should have_content "Johnathon McKenzie"
    end
    page.execute_script("$.deck('next')")

    find('section.deck-current').should have_content "Helps"
    page.execute_script("$.deck('next')")

    within 'section.deck-current' do
      page.should have_content "Interestings"
      page.should have_content("Linux 3.2 out")
      page.should have_content("Linus Torvalds")
      page.should have_content("Rails 62 is out")
      page.should_not have_selector('.in')
      first('a[data-toggle]').click
      page.should have_selector('.in')
    end
    page.execute_script("$.deck('next')")

    find('section.deck-current').should have_content "Events"
    page.should have_css('section.deck-current', text: 'Today')
    page.should have_css('.today + ul li', text: 'Happy Hour')
    page.should have_css('section.deck-current', text: 'Tomorrow')
    page.should have_css('.tomorrow + ul li', text: 'Baseball')
    page.should have_css('section.deck-current', text: 'Upcoming')
    page.should have_css('.upcoming + ul li', text: 'Party')
    find('section.deck-current').should_not have_content "Meetup"
    find('section.deck-current').should_not have_content("Rails 62 is out")
    page.execute_script("$.deck('next')")

    within 'section.deck-current' do
      page.should_not have_content "Events"
      page.should have_content "Woohoo"
    end

    all('.exit-presentation').first.click

    current_path.should == standup_items_path(standup)
  end
end
