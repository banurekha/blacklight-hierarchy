require 'spec_helper'

describe "catalog" do
  use_vcr_cassette "solr"
  before(:each) do
    CatalogController.blacklight_config = Blacklight::Configuration.new
    CatalogController.configure_blacklight do |config|
      config.index.show_link = 'title_display'
      config.default_solr_params = {
        :per_page => 10
      }
      config.add_facet_field 'tag_facet', :label => 'Tag', :partial => 'blacklight/hierarchy/facet_hierarchy'
    config.facet_display = {
      :hierarchy => {
        'tag' => [nil]
      }
    }
      
    end
  end
  it "should display the hierarchy" do
    visit '/'
    puts page.html.inspect
    page.should have_selector('li.h-node', :text => 'a')
    page.should have_selector('li.h-node > ul > li.h-node', :text => 'b')
    page.should have_selector('li.h-node li.h-leaf', :text => 'c 30')
    page.should have_selector('li.h-node li.h-leaf', :text => 'd 25')
    page.should have_selector('li.h-node > ul > li.h-node', :text => 'c')
    page.should have_selector('li.h-node li.h-leaf', :text => 'd 5')
    page.should have_selector('.facet-hierarchy > li.h-leaf', :text => 'n 1')
    page.should have_selector('li.h-node li.h-leaf', :text => 'q 25')
    page.should have_selector('li.h-node', :text => 'x')
    page.should have_selector('li.h-node > ul > li.h-leaf', :text => 'y 5')
  end

  it "should properly link the hierarchy" do
    visit '/'
    page.all(:css, 'li.h-leaf a').map { |a| a[:href].to_s }.should include(catalog_index_path('f' => { 'tag_facet' => ['n'] }))
    page.all(:css, 'li.h-leaf a').map { |a| a[:href].to_s }.should include(catalog_index_path('f' => { 'tag_facet' => ['a:b:c'] }))
    page.all(:css, 'li.h-leaf a').map { |a| a[:href].to_s }.should include(catalog_index_path('f' => { 'tag_facet' => ['x:y'] }))
  end
end
