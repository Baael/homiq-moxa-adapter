module.exports = (RED)->

  crc    = require('crc')
  client = require("redis").createClient(6379, '192.168.0.111')
  ser = 0

  RED.pkts = {}

  MoxaEncoder = (config)->

    RED.nodes.createNode(this,config)

    node   = this

    this.on 'input', (msg)->

      [path, value]   = msg.topic.split(':')
      [..., cmd, dst] = path.split('/')

      value ||= msg.payload

      client.get "devices:names:#{path.replace('/set/','')}", (err, obj)->
        return if !obj
        [cmd,dst] = obj.split('/')

        RED.pkts[cmd] ||= {}
        RED.pkts[cmd][dst] ||= 0
        RED.pkts[cmd][dst] = 0 if RED.pkts[cmd][dst] > 1024
        ser = RED.pkts[cmd][dst] += 1

        packet = [cmd,value,0,dst,ser,'s']
        packet.push crc.crc81wire packet.join("")

        node.send payload: "<;#{packet.join(';')};>\r\n"


  RED.nodes.registerType("moxa-encoder",MoxaEncoder)
