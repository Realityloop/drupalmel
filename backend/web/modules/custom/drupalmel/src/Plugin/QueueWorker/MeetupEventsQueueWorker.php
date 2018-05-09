<?php

namespace Drupal\drupalmel\Plugin\QueueWorker;

use Drupal\Core\Queue\QueueWorkerBase;
use Drupal\node\Entity\Node;

/**
 * Class MeetupEventsQueueWorker.
 *
 * @QueueWorker(
 *   id = "drupalmel_meetup_events_queue",
 *   title = @Translation("DrupalMel: Meetup events queue worker")
 * )
 */
class MeetupEventsQueueWorker extends QueueWorkerBase {

  /**
   * {@inheritdoc}
   */
  public function processItem($data) {
    Node::create([
      'type' => 'event',
      'uid' => 1,
      'title' => $data['name'],
      'created' => $data['created'] / 1000,
      'meetup_id' => $data['id'],
      'time' => $data['time'] / 1000,
      'location' => [
        'lat' => $data['venue']['lat'],
        'lng' => $data['venue']['lon'],
      ],
    ])->save();
  }

}
