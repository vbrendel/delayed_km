#KissMetrics with using delayed jobs
#Based on https://github.com/vbrendel/delayed_km/blob/master/lib/km.rb
class DKM
  @id = nil
  @key = nil

  class << self
    def identity
      @id
    end

    def api_key
      @key
    end

    def host
      "trk.kissmetrics.com"
    end

    def init(key)
      @key = key
    end

    def identify(id)
      @id = id
    end

    def record(action, props = {})
      raise ArgumentError, "You must set an API key" if !@key
      raise ArgumentError, "You must identify a user first" if !@id
      props = hash_keys_to_str(props)
      props.update("_n" => action)
      props.update("_p" => @id)
      props.update("_k" => @key)

      if props["_t"]
        props['_d'] = "1"
      else
        props['_t'] = Time.now.to_i.to_s
      end

      HTTParty.delay.get("http://#{DKM.host}/e?" + props.to_params)
    end

    def alias(name, alias_to)
      raise ArgumentError, "You must set an API key" if !@key
      raise ArgumentError, "You must identify a user first" if !@id
      p = {
          '_n' => alias_to,
          '_p' => name,
          '_k' => @key,
      }
      HTTParty.delay.get("http://#{DKM.host}/a?" + p.to_params)
    end

    def set(props = {})
      raise ArgumentError, "You must set an API key" if !@key
      raise ArgumentError, "You must identify a user first" if !@id
      props = hash_keys_to_str(props)

      props.update("_p" => @id)
      props.update("_k" => @key)

      if props["_t"]
        props['_d'] = "1"
      else
        props['_t'] = Time.now.to_i.to_s
      end

      HTTParty.delay.get("http://#{DKM.host}/s?" + props.to_params)
    end

    protected
    #This is from the offical km.rb
    def hash_keys_to_str(hash)
      Hash[*hash.map { |k, v| k.class == Symbol ? [k.to_s, v] : [k, v] }.flatten] # convert all keys to strings
    end
  end

end
