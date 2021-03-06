class DependencyWheelController < ApplicationController

  def recursive_dependencies
    lang    = Product.decode_language( params[:lang] )
    key     = Product.decode_prod_key params[:key]
    version = Version.decode_version params[:version]
    scope   = params[:scope]
    scope   = nil if scope.to_s.strip.empty?
    respond_to do |format|
      format.json {
        if Product::A_LANGS_DEP_GRAPH.include?(lang)
          circle = CircleElementService.dependency_circle( lang, key, version, scope )
          resp = CircleElementService.generate_json_for_circle_from_hash( circle )
          render :json => "[#{resp}]"
        else
          render :json => "[{\"success\": \"ok\"}]"
        end
        # circle = CircleElement.fetch_circle( lang, key, version, scope )
        # if circle && !circle.empty?
        #   resp = CircleElement.generate_json_for_circle_from_array( circle )
        # else
          # circle = CircleElement.dependency_circle( lang, key, version, scope )
          # CircleElement.store_circle( circle, lang, key, version, scope )
          # resp = CircleElement.generate_json_for_circle_from_hash( circle )
        # end
        # render :json => "[#{resp}]"
        # render :json => "[{\"success\": \"ok\"}]"
      }
    end
  end

  def project_recursive_dependencies
    id = params[:id]
    project = Project.find_by_id(id)
    dependencies = project.known_dependencies
    hash = Hash.new
    dependencies.each do |dep|
      element = CircleElement.new
      element.init_arrays
      element.dep_prod_key = dep.prod_key
      element.version = dep.version_requested
      element.level = 0
      element.text = dep.name
      element.text = dep.prod_key if element.text.nil?
      if dep.version_requested && !dep.version_requested.empty?
        element.text += ":#{dep.version_requested}"
      end
      hash[dep.prod_key] = element
    end
    circle = CircleElementService.fetch_deps(1, hash, Hash.new, project.language)
    respond_to do |format|
      format.json {
        resp = CircleElementService.generate_json_for_circle_from_hash(circle)
        render :json => "[#{resp}]"
      }
    end
  end

  def image_path
    image_key = params[:key]
    image_version = params[:version]
    scope = params[:scope]
    url = S3.infographic_url_for("#{image_key}:#{image_version}:#{scope}.png")
    respond_to do |format|
      format.json {
        if url_exist?(url)
          render :json => "#{url}"
        else
          render :json => 'nil'
        end
      }
    end
  end

  def upload_image
    image_bin = params[:image]
    image_key = params[:key]
    image_version = params[:version]
    scope = params[:scope]
    filename = "#{image_key}:#{image_version}:#{scope}.png"
    image_bin.gsub!(/data:image\/png;base64,/, '')
    AWS::S3::S3Object.store(
      filename,
      Base64.decode64(image_bin),
      Settings.instance.s3_infographics_bucket,
      :access => 'public-read')
    url = S3.infographic_url_for(filename)
    respond_to do |format|
      format.json {
        render :json => "#{url}"
      }
    end
  end

  private

    def url_exist?(url_path)
      url = URI.parse(url_path)
      req = Net::HTTP.new(url.host, url.port)
      res = req.request_head(url.path)
      if res.code == '200'
        return true
      else
        return false
      end
    rescue => e
      Rails.logger.error e.message
      Rails.logger.error e.backtrace.join("\n")
      return false
    end

end
