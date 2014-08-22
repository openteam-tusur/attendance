class Statistic::Reader < Statistic::Base
  attr_accessor :context

  def initialize(context)
    self.context = context
  end

  def attendance_by_date(from: nil, to: nil)
    get('by_date').inject({}) do |h, (k, v)|
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
        next unless date >= from && date <= to
        hash['attendance'] += a['attendance'].to_i
        hash['total']      += a['total'].to_i
        hash
      end
      h[k] = (res['attendance'].to_i*100.0/res['total']).round(1)
      h
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
