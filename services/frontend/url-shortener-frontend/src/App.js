import React from 'react';
import './App.css';
import { getSlug } from './api';

class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = {lastRequest: {}, requestedDestination: null};
  }

  handleSubmit = async (e) => {
    e.preventDefault()
    const requestedDestination = this.state.requestedDestination
    const response = await getSlug(requestedDestination)
    if(response.ok) {
      this.setState({
        lastRequest: {
          returnedURL: response.headers.get("Content-Location"),
          errorMessage: null,
          requestedDestination: requestedDestination
        }
      })
    } else {
      const errorMessage = await response.text()
      this.setState({
        lastRequest: {
          errorMessage: errorMessage,
          returnedURL: null,
          requestedDestination: requestedDestination
        }
      })
    }

  }

  render() {
    return (
      <div>
        <div className='instructions'>
          <span>Please Enter the desired URL</span>
        </div>
        {this.state.lastRequest.errorMessage &&
          <span data-testid="error_message">{this.state.lastRequest.errorMessage}</span>
        }
        {this.state.lastRequest.returnedURL &&
          <div>
            <span>{this.state.lastRequest.requestedDestination}:  </span>
            <a data-testid='short_url' href={this.state.lastRequest.returnedURL}>{this.state.lastRequest.returnedURL}</a>
          </div>
        }

        <div className='form_wrapper'>
          <form onSubmit={this.handleSubmit}>
            <label htmlFor="target_url">Where do you want to go?</label>
            <input
              type='text'
              name='target_url'
              id='target_url'
              onChange={e => this.setState({requestedDestination: e.target.value})}
            />
            <button type="submit">Submit</button>
          </form>
        </div>
      </div>
    );
  }
}

export default App;
