module ApplicationHelper
  def breadcrumbs(*links)
    content_tag :nav, aria: { label: "breadcrumb" }, class: "mb-3" do
      safe_join(
        links.map.with_index do |(name, path), index|
          if index == links.length - 1
            content_tag(:span, name, class: "fw-bold")
          else
            link_to(name, path, class: "text-decoration-none")
          end
        end,
        " / "
      )
    end
  end
end
