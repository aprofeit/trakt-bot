module PagesHelper
  def pretty_aired_at(episode)
    no_mobile_time_zone = content_tag(:span, class: 'no-mobile') do
      episode.aired_at.in_time_zone('EST').strftime('%Z')
    end

    raw(episode.aired_at.in_time_zone('EST').strftime('%-I:%M %P ') + no_mobile_time_zone)
  end

  def episode_done_badge(episode)
    if episode.aired? && episode.downloaded?
      content_tag(:span, class: 'badge badge-success') do
        'downloaded'
      end
    elsif episode.aired?
      content_tag(:span, class: 'badge badge-warning') do
        'aired'
      end
    end
  end
end
