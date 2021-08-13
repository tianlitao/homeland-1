# frozen_string_literal: true

class PhotosController < ApplicationController
  load_and_authorize_resource
  skip_before_action  :verify_authenticity_token

  def create
    if params[:file].blank?
      render json: {ok: false}, status: 400
      return
    end
    # 浮动窗口上传
    @photo = Photo.new(image: params[:file], user: current_user)
    if @photo.save
      render json: {ok: true, url: @photo.image.url(:large), file_path: @photo.image.url(:large), success: true}
    else
      render json: {ok: false, message: @photo.errors.full_messages.join, success: false}, status: 400
    end
  end

  def simditor_upload
    if params[:upload_file].blank?
      render json: {success: false}, status: 400
      return
    end
    @photo = Photo.new(image: params[:upload_file], user: current_user)
    if @photo.save
      render json: {success: true, file_path: @photo.image.url(:large)}
    else
      render json: {success: false, message: @photo.errors.full_messages.join}, status: 400
    end
  end

end
