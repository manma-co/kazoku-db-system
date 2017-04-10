module Response
  def json_response(object, status = :ok)
    info = {
        meta: {
            requesturi: request.fullpath,
            method: request.method,
            time: Time.now,
            extra: ""
        },
        data: object,
        links: ""
    }
    render json: info, status: status
  end
end