class NewsParsersController < ApplicationController
  before_action :set_news_parser, only: [:show, :destroy]

  # GET /news_parsers
  # GET /news_parsers.json
  def index
  end

  # GET /news_parsers/1
  # GET /news_parsers/1.json
  def show
  end

  # POST /news_parsers
  # POST /news_parsers.json
  def create
    # @news_parser = NewsParser.new([1,2,3], {1 => 3})
    # @news_parser.save
    @news_parser = NewsParser.new
    params[:query].each_value do |value|
      unless value.empty?
        @news_parser.add_query value
      end
    end
    @news_parser.run!
    @news_parser.save
    render 'show'
    # respond_to do |format|
    #   if @news_parser.save
    #     format.html { redirect_to @news_parser}
    #     format.json { render action: 'show', status: :created, location: @news_parser }
    #   else
    #     format.html { render action: 'index' }
    #     format.json { render json: @news_parser.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PATCH/PUT /news_parsers/1
  # PATCH/PUT /news_parsers/1.json
  def update
    respond_to do |format|
      if @news_parser.update(news_parser_params)
        format.html { redirect_to @news_parser, notice: 'News parser was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @news_parser.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /news_parsers/1
  # DELETE /news_parsers/1.json
  def destroy
    @news_parser.destroy
    respond_to do |format|
      format.html { redirect_to news_parsers_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_news_parser
      @news_parser = NewsParser.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def news_parser_params
      params.require(:news_parser).permit(:contents, :queries)
    end

end
