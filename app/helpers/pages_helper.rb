module PagesHelper
  def pretty_aired_at(episode)
    no_mobile_time_zone = content_tag(:span, class: 'no-mobile') do
      episode.aired_at.in_time_zone('EST').strftime('%Z')
    end

    raw(episode.aired_at.in_time_zone('EST').strftime('%-I:%M %P ') + no_mobile_time_zone)
  end

  def episode_done_badge(episode)
    text, klass = if episode.aired? && episode.downloaded?
      ['downloaded', 'badge badge-success']
    elsif episode.aired?
      ['aired', 'badge badge-warning']
    end

    content_tag(:span, text, class: klass)
  end
end
