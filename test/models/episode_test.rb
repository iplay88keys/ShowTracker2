require 'test_helper'

class EpisodeTest < ActiveSupport::TestCase
  test "setup" do
    assert_equal(Episode.count, 3)
  end

  test "getEpisodesForSeasonWithWatches" do
    user_id = 1
    series_id = 2
    season_id = 1

    watchOne, _ = setupWatches(user_id)

    returned = Episode.getEpisodesForSeasonWithWatches(user_id, series_id, season_id)

    assert_equal(returned["episodes"].length, 2)
    assert_includes(returned["episodes"], episodes(:one))
    assert_includes(returned["episodes"], episodes(:two))
    refute_includes(returned["episodes"], episodes(:three))

    assert_equal(returned["extras"]["season_id"], season_id)
    assert_equal(returned["extras"]["series_id"], series_id)

    assert_equal(returned["watches"].length, 1)
    assert_includes(returned["watches"], watchOne)

    assert_equal(returned["all"], false)
  end

  test "getAllEpisodesWithWatches" do
    user_id = 1
    series_id = 2

    watchOne, watchTwo = setupWatches(user_id)

    returned = Episode.getAllEpisodesWithWatches(user_id, series_id)

    assert_equal(returned["episodes"].length, 3)
    assert_includes(returned["episodes"], episodes(:one))
    assert_includes(returned["episodes"], episodes(:two))
    assert_includes(returned["episodes"], episodes(:three))

    assert_equal(returned["extras"]["series_id"], series_id)

    assert_equal(returned["watches"].length, 2)
    assert_includes(returned["watches"], watchOne)
    assert_includes(returned["watches"], watchTwo)

    assert_equal(returned["all"], true)
  end

  def setupWatches(user_id)
    episodeOne = episodes(:one)
    watchOne = Watch.create(
      episode_id: episodeOne.id,
      user_id: user_id,
      series_id: episodeOne.series_id,
      season_id: episodeOne.season_id
    )
    watchOne.save!

    episodeTwo = episodes(:three)
    watchTwo = Watch.create(
      episode_id: episodeTwo.id,
      user_id: user_id,
      series_id: episodeTwo.series_id,
      season_id: episodeTwo.season_id
    )
    watchTwo.save!

    return episodeOne.id, episodeTwo.id
  end
end
