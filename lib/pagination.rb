module Pagination
  MAX_PAGINATION_LIMIT = 20
  def per_page
    params.fetch(:per_page, MAX_PAGINATION_LIMIT).to_i
  end

  def page_number
    page = [params.fetch(:page, 1).to_i, 1].max
    (page - 1) * per_page
  end
end
