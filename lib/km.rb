class KM
  @id = nil
  @key = nil
  
  class << self
    
    def init(key)
      @key = key
    end

    def identify(id)
      @id = id
    end

    def record(e)
      p = {
        '_n' => e,
        '_p' => @id,
        '_t' => Time.now.to_i.to_s,
        '_k' => @key,
      }
      HTTParty.delay.get('http://trk.kissmetrics.com/e?' + p.to_params)
    end

    def alias(name, alias_to)
      p = {
        '_n' => alias_to,
        '_p' => name,
        '_t' => Time.now.to_i.to_s,
        '_k' => @key,
      }
      HTTParty.delay.get('http://trk.kissmetrics.com/a?' + p.to_params)
    end

    def set(p)
      p['_p'] = name
      p['_t'] = Time.now.to_i.to_s
      p['_k'] = @key
      HTTParty.delay.get('http://trk.kissmetrics.com/s?' + p.to_params)
    end
    
  end
  
end
