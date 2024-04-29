# frozen_string_literal: true

# ファイルに引数として与えられた6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5
# のような値をフレームごとに分割するメソッドを備えたモジュール
module ScoreArrangement
  def arrange_scores(scores)
    scores_each_frame = []
    until scores.empty?
      scores_each_frame << if scores_each_frame.size == 9
                             scores.shift(3)
                           elsif scores.first == 'X'
                             scores.shift(1)
                           else
                             scores.shift(2)
                           end
    end
    scores_each_frame
  end
end
