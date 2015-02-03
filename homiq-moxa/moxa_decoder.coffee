module.exports = (RED)->

  stored_packets = []


  HomiqDecode = (config)->

    RED.nodes.createNode(this,config)

    uniq = (packet)->
      return false if (stored.indexOf(packet) > -1 )
      stored.push(packet)
      stored = stored.slice(-50)
      true


    decode = (packet)->

      # HAddr
      #<;ID;VALUE;DESTINATION;0;SERIAL;TYPE;220;>\r\n",

      [id,value,destination,x,serial,type] = "#{packet}".split(';')[1..6]
      {
        topic:   "#{id}/#{destination}"
        payload: parseFloat(value)
      }


    this.on 'input', (msg)->

      packet = msg.payload.replace(/\\n|\\r/g,'')

      return unless uniq(packet)

      msg = decode(packet)

      client.get "devices:ids:#{msg.topic}", (err, obj)->
        msg.topic = "/#{obj}:#{msg.payload}"
        node.send msg


  RED.nodes.registerType("homiq-decrypt",HomiqDecrypt)
