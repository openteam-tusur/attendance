class Statistic::Reader < Statistic::Base
  attr_accessor :context, :route_namespace

  def initialize(context, route_namespace)
    self.context = context
    self.route_namespace = route_namespace
  end

  def redis
    @redis ||= Statistic::RedisReader.instance
  end

  def attendance_by_date(from: nil, to: nil)
    get('dates').inject({}) do |h, (k, v)|
      date = Date.parse(k)
      h[k] = (v['attendance'].to_i*100.0/v['total']).round(1) if date >= from && date <= to
      h
    end
  end

  def attendance_by(kind, from: nil, to: nil)
    get(kind).inject({}) do |h, (k, v)|
      res = {'attendance' => 0, 'total' => 0}
      v.inject(res) do |hash, (d, a)|
        date = Date.parse(d)
        if date >= from && date <= to
          hash['attendance'] += a['attendance'].to_i
          hash['total']      += a['total'].to_i
        end
        hash
      end
      opts = { :value => (res['attendance'].to_i*100.0/res['total']).round(1) }
      opts.merge! :url => "/#{route_namespace}/#{kind}/#{k}" if route_namespace
      h[k] = opts unless res['total'].zero?
      h
    end.sort
  end

  def attendance_by_date_of_kind(kind, ids, from: nil, to: nil)
    if ids.is_a? Array
      res = {}

      ids.each do |id|
        get(kind)[id].each do |d, v|
          date = Date.parse(d)
          if date >= from && date <= to
            res[date] ||= {}
            res[date].merge!(v) {|k, old, new| old+new}
          end
        end
      end

      res.inject({}) { |h, (d, v)| h[d] = (v['attendance'].to_i*100.0/v['total'].to_i).round(1); h}
    else
      get(kind)[ids].inject({}) do |h, (k, v)|
        date = Date.parse(k)
        h[k] = (v['attendance'].to_i*100.0/v['total']).round(1) if date >= from && date <= to
        h
      end
    end
  end

  private

  def get(kind)
    res = {}

    get_all("#{uniq_id}:#{kind}").each do |k, v|
      key1, key2, key3 = k.split(':')
      res[key1]  ||= {}
      if key3
        res[key1][key2] ||= {}
        res[key1][key2][key3] = v.to_i
      else
        res[key1][key2] = v.to_i
      end
    end

    res
  end
end
