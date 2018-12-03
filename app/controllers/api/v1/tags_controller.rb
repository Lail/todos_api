class Api::V1::TagsController < ApplicationController
  before_action :set_tag, only: [:update, :destroy]

  # GET /tags
  def index
    @tags = Tag.order(:created_at).includes(:tasks)

    render jsonapi: @tags, include: :tasks
  end

  # POST /tags
  def create
    @tag = Tag.new(tag_params)

    if @tag.save
      render jsonapi: @tag, include: :tasks, status: :created
    else
      render jsonapi_errors: @tag.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tags/1
  def update
    if @tag.update(tag_params)
      render jsonapi: @tag, include: :tasks
    else
      render jsonapi_errors: @tag.errors, status: :unprocessable_entity
    end
  end

  # DELETE /tags/1
  def destroy
    @tag.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tag
      @tag = Tag.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def tag_params
      params.require(:data).require(:attributes).permit(:title)
    end
end
