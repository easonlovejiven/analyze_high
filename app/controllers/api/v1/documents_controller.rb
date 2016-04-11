# coding: utf-8
class Api::V1::DocumentsController < Admin::BaseController

	def create
		@document = Document.new(document_params)

		if @document.save
			$redis.lpush("documents", @document.id)
			render json: {state: true}
		else
			render json: {state: false}
		end
	end


	private

	def document_params
		params.require(:document).permit(:file, :status, :state)
	end
	
end