class KakaoController < ApplicationController
  #defult 화면
  def keyboard
    @home = {type: :buttons, buttons: %w(김성준 김은식 임규산)}
    render json: @home 
  end
  #응답 부분
  def message
    puts params[:user_key]
    @answer = {message: { text: params[:content].to_s+" 다 덤벼!!"}, keyboard: {type: :buttons , buttons: %w(김성준 김은식 임규산)}}
    render json: @answer
  end
end
