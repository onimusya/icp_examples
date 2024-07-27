// Publisher
import List "mo:base/List";
import Debug "mo:base/Debug";
import Principal "mo:base/Principal";

actor Publisher {

  type Counter = {
    topic : Text;
    value : Nat;
  };

  type Subscriber = {
    topic : Text;
    callback : shared Counter -> ();
  };

  stable var subscribers = List.nil<Subscriber>();

  public shared(msg) func subscribe(subscriber : Subscriber) {
    let caller : Principal = msg.caller;
    let principal = Principal.fromActor(Publisher);
    Debug.print("[pub][subscribe] pub id:" # Principal.toText(principal));
    Debug.print("[pub][subscribe] caller id:" # Principal.toText(caller));
    Debug.print("[pub][subscribe] topic:" # subscriber.topic);

    subscribers := List.push(subscriber, subscribers);
  };

  public shared(msg) func publish(counter : Counter) {
    let caller : Principal = msg.caller;
    let principal = Principal.fromActor(Publisher);
    Debug.print("[pub][publish] pub id:" # Principal.toText(principal));
    Debug.print("[pub][publish] caller id:" # Principal.toText(caller));
    Debug.print("[pub][publish] topic:" # counter.topic);

    for (subscriber in List.toArray(subscribers).vals()) {
      if (subscriber.topic == counter.topic) {
        
        subscriber.callback(counter);
      };
    };
  };
}
