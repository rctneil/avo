# frozen_string_literal: true

require "rails_helper"

RSpec.describe "LocationField", type: :system do
  describe "without value" do
    let(:city) { create :city, latitude: nil, longitude: nil }

    context "new" do
      it "shows empty location field" do
        visit "/admin/resources/cities/new"

        expect(find_field_element("coordinates")).to have_text ""
      end
    end

    context "show" do
      it "shows empty location field" do
        visit "/admin/resources/cities/#{city.id}"

        expect(find_field_element("coordinates")).to have_text empty_dash
      end
    end

    context "edit" do
      it "has lat/long fields and placeholders" do
        visit "/admin/resources/cities/#{city.id}/edit"

        coordinates_element = find_field_element("coordinates")

        expect(coordinates_element).to have_text "COORDINATES"

        expect(find_by_id("city_coordinates_latitude", visible: false)).to have_text("")
        expect(find_by_id("city_coordinates_latitude", visible: false)[:placeholder]).to have_text("Enter latitude")

        expect(find_by_id("city_coordinates_longitude", visible: false)).to have_text("")
        expect(find_by_id("city_coordinates_longitude", visible: false)[:placeholder]).to have_text("Enter longitude")
      end

      it "changes the city coordinates" do
        visit "/admin/resources/cities/#{city.id}/edit"

        fill_in "Enter latitude", with: "1.0"
        fill_in "Enter longitude", with: "2.0"

        save

        click_on "Edit"

        expect(find_by_id("city_coordinates_latitude").value).to eq("1.0")
        expect(find_by_id("city_coordinates_longitude").value).to eq("2.0")
      end
    end
  end

  describe "with regular value" do
    # Eiffel Tower coordinates used
    let!(:city) { create :city, latitude: 48.8584, longitude: 2.2945 }

    context "show" do
      it "renders a map" do
        Avo::Fields::LocationField.any_instance.stub(:render_map).and_return("map_content_here")
        visit "/admin/resources/cities/#{city.id}"

        expect(page).to have_text("map_content_here")
      end
    end

    context "edit" do
      it "has filled lat/long values in editor" do
        visit "/admin/resources/cities/#{city.id}/edit"

        expect(find_by_id("city_coordinates_latitude").value).to eq("48.8584")
        expect(find_by_id("city_coordinates_longitude").value).to eq("2.2945")
      end
    end
  end
end
