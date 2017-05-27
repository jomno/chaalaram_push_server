require 'fcm'
class HomeController < ApplicationController
  before_action :set_fcm
  def index
  end
  # post /home/save 토큰 저장하자
  def save_token
    @send = params[:token]
      User.create(token: @send)
    render :send
  end
  # get /home/send 전체한테 보내자
  def send_all_user
    registration_ids= Array.new # an array of one or more client registration tokens
    User.all.each do |u|
      registration_ids.push(u.token)
    end
    options = {data: {message: "there is new posting", order: 100}} #order는 100이 그 선택지 200이 알람
    @response = @fcm.send(registration_ids, options)
    render :send
  end
  # post /home/request 한 사람한테 선택지를 보내자!
  def send_one_order
    to= [params[:token]]
    options = {data: {message: "there is new posting", order: 100}}#order는 100이 그 선택지 200이 알람
    @response = @fcm.send(to, options)
    render :send
  end
  
  # post /home/report 요청 받자!
  def report
    #status 100이 사고 200 이 차 고장 300이 낫띵
    @status = params[:status]
    puts @status
    case @status
    when "100"
      send_all_alarm(100,params[:token])
    when "200"
      send_all_alarm(200,params[:token])
    when "300"
    end
    render :send
  end
  
  private
  def set_fcm
    @fcm = FCM.new(ENV['fcm_key'])
  end
  
  def send_one_alarm(status,token)
    
    fcm = FCM.new(ENV['fcm_key'])
    to= [token]
    case status
    when 100
      options = {data: {message: Time.now.strftime("%m월 %d일 %H시 %M분") + " 경 근처에서 사고가 났습니다.", order: 200}}#order는 100이 그 선택지 200이 알람
    when 200
      options = {data: {message: Time.now.strftime("%m월 %d일 %H시 %M분") + " 경 근처에서 차 고장이 났습니다.", order: 200}}#order는 100이 그 선택지 200이 알람
    end
    @response = fcm.send(to, options)
  end
  
  def send_all_alarm(status, token)
    fcm = FCM.new(ENV['fcm_key'])
    registration_ids= Array.new # an array of one or more client registration tokens
    User.where.not(token: token).each do |u|
      registration_ids.push(u.token)
    end
    case status
      when 100
        options = {data: {message: Time.now.strftime("%m월 %d일 %H시 %M분") + " 경 근처에서 사고가 났습니다.", order: 200}}#order는 100이 그 선택지 200이 알람
      when 200
        options = {data: {message: Time.now.strftime("%m월 %d일 %H시 %M분") + " 경 근처에서 차 고장이 났습니다.", order: 200}}#order는 100이 그 선택지 200이 알람
    end
    @response = fcm.send(registration_ids, options)
  end
end