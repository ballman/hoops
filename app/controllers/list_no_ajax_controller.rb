class ListNoAjaxController < ApplicationController
  def index
    @items = Item.find_recent
  end

  def add_item
    sleep(4)
    item = Item.new(params[:item_body])
    render(:partial => "item", :object => item, :layout => false)
  end
end
